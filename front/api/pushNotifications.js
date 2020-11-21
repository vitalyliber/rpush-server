import axios from 'axios'

export const sendPushNotification = ({
  external_key,
  title,
  message,
  environment,
  headers,
}) => {
  return axios({
    method: 'post',
    url: '/push_notifications',
    data: {
      message: {
        title,
        message,
      },
      mobile_user: {
        external_key,
        environment,
      },
    },
    credentials: 'same-origin',
    headers,
  }).then(({ data, status }) => {
    console.log(data, status)
  })
}
