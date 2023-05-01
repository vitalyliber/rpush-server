import axios from 'axios'

export const sendPushNotification = ({
  external_key,
  title,
  message,
  environment,
  fieldData,
  deviceType,
  dataNotification
}) => {
  const access_token = localStorage.getItem('access_token')
  return axios({
    method: 'post',
    url: '/push_notifications',
    data: {
      device_type: deviceType,
      message: {
        title,
        message,
        data: fieldData,
        data_notification: dataNotification,
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
