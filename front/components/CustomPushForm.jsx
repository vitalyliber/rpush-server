import React, {useEffect, useState} from 'react'
import dig from 'object-dig'
import { useForm } from 'react-hook-form'
import {
  Form,
  FormGroup,
  Input,
  FormFeedback,
  Label,
  FormText,
} from 'reactstrap'
import { sendPushNotification } from '../api/pushNotifications'
import dynamic from "next/dynamic";
const ReactJson = dynamic(import("react-json-view"), {ssr: false});
import createPersistedState from "use-persisted-state";

function CustomPushForm() {
  const storageDeviceType = createPersistedState("devise_type");
  const storageFieldData = createPersistedState("field_data");
  const storageEnvironment = createPersistedState("environment");
  const storageExternalKey = createPersistedState("external_key");
  const storageTitle = createPersistedState("title");
  const storageMessage = createPersistedState("message");

  const [loading, setLoading] = useState(false);
  const [environment, setEnvironment] = storageEnvironment('development');
  const [fieldData, setFieldData] = storageFieldData({});
  const [deviceType, setDeviceType] = storageDeviceType("all");
  const [externalKey, setExternalKey] = storageExternalKey("");
  const [title, setTitle] = storageTitle("");
  const [message, setMessage] = storageMessage("");

  const [trigger, setTrigger] = useState(false);

  useEffect(() => {
    setTrigger(!trigger)
  }, [deviceType])

  const handleErrors = (keys) => {
    const result = dig(errors, ...keys)
    return <FormFeedback>{result && result.message}</FormFeedback>
  }
  const { register, handleSubmit, errors } = useForm({
    mode: 'onBlur',
  })
  const required = {
    value: true,
    message: 'Required field',
  }
  const onSubmit = async (data) => {
    try {
      setLoading(true)
      console.log('onSubmit', data, deviceType, environment, fieldData )
      await sendPushNotification({
        ...data,
        environment,
        fieldData,
        deviceType
      })
    } catch (e) {
      console.log('onSubmitError')
      alert('Something went wrong.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div>
      <h4>Push notification form</h4>
      <p>
        If you want to send a message to all users leave the "External Key"
        field blank
      </p>
      <Form invalid={errors} onSubmit={handleSubmit(onSubmit)}>
        <FormGroup>
          <Label>Title</Label>
          <Input
            invalid={!!dig(errors, 'title')}
            type="text"
            placeholder="Title"
            name="title"
            innerRef={register({
              required,
              maxLength: {
                value: 30,
                message: 'Max length 30',
              },
            })}
            value={title}
            onChange={(e) => setTitle(e.target.value)}
          />
          {handleErrors(['title'])}
        </FormGroup>
        <FormGroup>
          <Label>Message</Label>
          <Input
            invalid={!!dig(errors, 'message')}
            type="textarea"
            placeholder="Message"
            name="message"
            innerRef={register({
              required,
              maxLength: {
                value: 120,
                message: 'Max length 120',
              },
            })}
            value={message}
            onChange={(e) => setMessage(e.target.value)}
          />
          {handleErrors(['message'])}
        </FormGroup>
        <FormGroup>
          <Label>Data</Label>
          <ReactJson
              name={"data"}
              src={fieldData}
              onEdit={(res) => setFieldData(res.updated_src)}
              onAdd={(res) => setFieldData(res.updated_src)}
              onDelete={(res) => setFieldData(res.updated_src)}
          />
          {handleErrors(['data'])}
        </FormGroup>
        <FormGroup>
          <Label>External Key</Label>
          <Input
            invalid={!!dig(errors, 'external_key')}
            type="text"
            placeholder="External Key"
            name="external_key"
            innerRef={register({})}
            value={externalKey}
            onChange={(e) => setExternalKey(e.target.value)}
          />
          {handleErrors(['external_key'])}
          <FormText>
            It can be some uniq user server identifier for a user like email or
            database ID.
          </FormText>
        </FormGroup>
        <FormGroup>
          <Label>Devise type</Label>
          <Input
              type={"select"}
              className="mb-4"
              name={"device_type"}
              value={deviceType}
              onChange={(e) => setDeviceType(e.target.value)}
          >
            <option>all</option>
            <option>ios</option>
            <option>android</option>
          </Input>
        </FormGroup>
        <input
          disabled={loading}
          className="btn btn-primary btn-block mb-3"
          type="submit"
          value="Send"
        />
        <Input
          onChange={(el) => setEnvironment(el.target.value)}
          value={environment}
          type="select"
          name="select"
          id="exampleSelect"
          className="mb-4"
        >
          <option>development</option>
          <option>production</option>
        </Input>
      </Form>
    </div>
  )
}

CustomPushForm.propTypes = {}

export default CustomPushForm
