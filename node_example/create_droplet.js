// prepare
//   npm install --save do-wrapper


const DigitalOcean = require("do-wrapper").default;

const TOKEN = "xxxxxxxxxxxxxxxxxxxx"; // you token
const SSHKEYID = 12345678; // your key id

const DROPLET_NAME = "by-code";

const options = {
  name: DROPLET_NAME,
  region: "sgp1",
  size: "s-1vcpu-1gb",
  image: "ubuntu-20-04-x64",
  ssh_keys: [SSHKEYID],
};

// Dropletを作成。初期化終了を待たずにすぐに戻る（IPアドレスはまだ確定していない）
const instance = new DigitalOcean(TOKEN);
instance.droplets.create(options)
  .then(data => console.log(data))
  .catch(err => console.error(err));
