import React, { useEffect, useState } from 'react'
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
import dynamic from 'next/dynamic'
const ReactJson = dynamic(import('react-json-view'), { ssr: false })
import createPersistedState from 'use-persisted-state'
import Link from 'next/link'

const getRealCustomValue = (value) => {
  let serverValue = 'all'
  if (value === 'ios') {
    serverValue = 'Apnsp8'
  }
  if (value === 'android') {
    serverValue = 'Firebase'
  }
  return serverValue
}

const convertToRealCustomValue = (value) => {
  let serverValue = 'all'
  if (value === 'Apnsp8') {
    serverValue = 'ios'
  }
  if (value === 'Firebase') {
    serverValue = 'android'
  }
  return serverValue
}

function CustomPushForm() {
  const storageDeviceType = createPersistedState('devise_type')
  const storageFieldData = createPersistedState('field_data')
  const storageDataNotification = createPersistedState('data_notification')
  const storageExternalKey = createPersistedState('external_key')
  const storageTitle = createPersistedState('title')
  const storageMessage = createPersistedState('message')

  const [loading, setLoading] = useState(false)
  const [fieldData, setFieldData] = storageFieldData({})
  const [dataNotification, setDataNotification] = storageDataNotification({})
  const [deviceType, setDeviceType] = storageDeviceType('all')
  const [externalKey, setExternalKey] = storageExternalKey('')
  const [title, setTitle] = storageTitle('')
  const [message, setMessage] = storageMessage('')

  const [trigger, setTrigger] = useState(false)

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
      console.log('onSubmit', data, deviceType, fieldData, dataNotification)
      await sendPushNotification({
        ...data,
        fieldData,
        deviceType,
        dataNotification,
      })
    } catch (e) {
      alert('Something went wrong.')
    } finally {
      alert('Push notifications sent successfully.')
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
            name={'data'}
            src={fieldData}
            onEdit={(res) => setFieldData(res.updated_src)}
            onAdd={(res) => setFieldData(res.updated_src)}
            onDelete={(res) => setFieldData(res.updated_src)}
          />
          {handleErrors(['data'])}
        </FormGroup>
        {(deviceType === 'all' || deviceType === 'android') && (
          <FormGroup>
            <Label>Data notification</Label>
            <ReactJson
              name={'dataNotification'}
              src={dataNotification}
              onEdit={(res) => setDataNotification(res.updated_src)}
              onAdd={(res) => setDataNotification(res.updated_src)}
              onDelete={(res) => setDataNotification(res.updated_src)}
            />
            {handleErrors(['dataNotification'])}
            <FormText>
              The field needs to setup channel_id and android_channel_id (links
              <Link
                href={
                  'https://stackoverflow.com/questions/45937291/how-to-specify-android-notification-channel-for-fcm-push-messages-in-android-8'
                }
                target={'_blank'}
              >
                {' stackowerflow '}
              </Link>
              and
              <Link
                href={
                  'https://developer.android.com/develop/ui/views/notifications#ManageChannels'
                }
                target={'_blank'}
              >
                {' docs'}
              </Link>
              )
            </FormText>
          </FormGroup>
        )}
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
          <Label>Cloud messaging providers</Label>
          <Input
            type={'select'}
            className="mb-4"
            name={'device_type'}
            value={getRealCustomValue(deviceType)}
            onChange={(e) =>
              setDeviceType(convertToRealCustomValue(e.target.value))
            }
          >
            <option>all</option>
            <option>Apnsp8</option>
            <option>Firebase</option>
          </Input>
        </FormGroup>
        <input
          disabled={loading}
          className="btn btn-primary btn-block mb-3"
          type="submit"
          value="Send"
        />
      </Form>
    </div>
  )
}

CustomPushForm.propTypes = {}

export default CustomPushForm
