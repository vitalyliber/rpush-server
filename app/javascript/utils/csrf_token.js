const csrfToken = document.querySelector("meta[name=csrf-token]").content || '';
export default csrfToken;
