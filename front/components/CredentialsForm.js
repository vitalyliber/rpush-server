import React, { useState, useContext } from 'react'
import dig from 'object-dig'
import { useForm } from 'react-hook-form'
import { Form, FormGroup, Input, FormFeedback } from 'reactstrap'
import { createCredential } from '../api/credentials'
import useCredentials from '../hooks/useCredentials'
import { Context } from './ContextProvider'

function CredentialsForm() {
  const { os } = useContext(Context)
  const { mutate } = useCredentials({ os })
  const [loading, setLoading] = useState(false)
  const { register, handleSubmit, errors, reset } = useForm({
    mode: 'onBlur',
  })
  const handleErrors = (keys) => {
    const result = dig(errors, ...keys)
    return <FormFeedback>{result && result.message}</FormFeedback>
  }
  const required = {
    value: true,
    message: 'Required field',
  }
  const onSubmit = async (data) => {
    console.log(data)
    try {
      setLoading(true)
      await createCredential({ data, os })
    } catch (e) {
      alert(e?.response?.data?.errors?.join(', '))
    } finally {
      setLoading(false)
      reset()
      mutate()
    }
  }
  return (
    <Form onSubmit={handleSubmit(onSubmit)}>
      <FormGroup>
        {os === 'android' && (
          <>
            <Input
              invalid={!!dig(errors, 'auth_key')}
              type="text"
              placeholder="Auth Key"
              name="auth_key"
              innerRef={register({
                required,
              })}
            />
            <small className="form-text text-muted">
              Firebase server
              <a
                target="_blank"
                href="https://firebase.google.com"
                className="text-info ml-1"
              >
                key
              </a>
            </small>
            {handleErrors(['auth_key'])}
          </>
        )}
        {os === 'ios' && (
          <>
            <Input
              className="mb-2"
              invalid={!!dig(errors, 'certificate')}
              type="textarea"
              rows="6"
              placeholder="Certificate"
              name="certificate"
              innerRef={register({
                required,
              })}
            />
            <small className="form-text text-muted">
              Certificate with extension
              <a
                target="_blank"
                href="https://github.com/rpush/rpush/wiki/Generating-Certificates"
                className="text-info ml-1"
              >
                .pem
              </a>
            </small>
            {handleErrors(['certificate'])}
            <Input
              className="mt-4"
              innerRef={register({
                required,
              })}
              type="select"
              name="environment"
            >
              <option>development</option>
              <option>production</option>
            </Input>
            {handleErrors(['environment'])}
            <Input
              className="mb-2 mt-3"
              invalid={!!dig(errors, 'password')}
              type="text"
              rows="6"
              placeholder="Password"
              name="password"
              innerRef={register({})}
            />
            {handleErrors(['password'])}
          </>
        )}
        <input
          disabled={loading}
          className="btn btn-primary btn-block mt-4 mb-3"
          type="submit"
          value="Add"
        />
      </FormGroup>
    </Form>
  )
}

export default CredentialsForm
