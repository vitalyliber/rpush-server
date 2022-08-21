import axios from 'axios'

export const sendPushNotification = ({
  external_key,
  title,
  message,
  environment,
  fieldData,
  headers,
}) => {
  const access_token = localStorage.getItem('access_token')
  return axios({
    method: 'post',
    url: '/push_notifications',
    data: {
      message: {
        title,
        message,
        data: JSON.stringify(fieldData)
      },
      mobile_user: {
        external_key,
        environment,
      },
    },
    credentials: 'same-origin',
    headers: {
      Authorization: `Bearer ${access_token}`,
    },
  }).then(({ data, status }) => {
    console.log(data, status)
  })
}
