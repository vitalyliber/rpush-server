import axios from 'axios'

export const getCredentials = async ({ os, access_token }) => {
  return axios({
    method: 'get',
    url: '/apps',
    params: { os },
    credentials: 'same-origin',
    headers: {
      Authorization: `Bearer ${access_token}`,
    },
  }).then(({ data, status }) => {
    console.log('getCredentials', data)
    return data.apps
  })
}

export const deleteCredential = ({ id, os }) => {
  const access_token = localStorage.getItem('access_token')
  return axios({
    method: 'delete',
    url: `/apps/${id}`,
    params: { os },
    credentials: 'same-origin',
    headers: {
      Authorization: `Bearer ${access_token}`,
    },
  }).then(({ data }) => {
    console.log('deleteCredential', data)
  })
}

export const createCredential = async ({ data, os }) => {
  const access_token = localStorage.getItem('access_token')
  return axios({
    method: 'post',
    url: '/apps',
    data: {
      app: {
        ...data,
        os,
      },
    },
    headers: {
      Authorization: `Bearer ${access_token}`,
    },
  })
}
