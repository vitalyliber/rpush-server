import React, { useState, useContext } from 'react'
import dig from 'object-dig'
import { useForm } from 'react-hook-form'
import { Form, FormGroup, Input, FormFeedback } from 'reactstrap'
import { createCredential } from '../api/credentials'
import useCredentials from '../hooks/useCredentials'
import { Context } from './ContextProvider'

function CredentialsForm() {
  const { os } = useContext(Context)
  const { data, mutate } = useCredentials({ os })
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
      reset()
      mutate()
    } catch (e) {
      alert(e?.response?.data?.errors?.join(', '))
    } finally {
      setLoading(false)
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
              className="mb-2 mt-3"
              invalid={!!dig(errors, 'apn_key')}
              type="textarea"
              placeholder="Apn Key"
              name="apn_key"
              rows="6"
              innerRef={register({
                required,
              })}
            />
            <small className="form-text text-muted">.p8 key</small>
            {handleErrors(['apn_key'])}
            <Input
              className="mb-2 mt-3"
              invalid={!!dig(errors, 'apn_key_id')}
              type="text"
              placeholder="Apn Key Id"
              name="apn_key_id"
              innerRef={register({
                required,
              })}
            />
            <small className="form-text text-muted">Example: CNX38P272R</small>
            {handleErrors(['apn_key_id'])}
            <Input
              className="mb-2 mt-3"
              invalid={!!dig(errors, 'team_id')}
              type="text"
              placeholder="Team Id"
              name="team_id"
              innerRef={register({
                required,
              })}
            />
            <small className="form-text text-muted">Example: 9P59H549VX</small>
            {handleErrors(['team_id'])}
            <Input
              className="mb-2 mt-3"
              invalid={!!dig(errors, 'bundle_id')}
              type="text"
              placeholder="Bundle Id"
              name="bundle_id"
              innerRef={register({
                required,
              })}
            />
            <small className="form-text text-muted">
              Example: com.casply.rpush
            </small>
            {handleErrors(['bundle_id'])}
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
