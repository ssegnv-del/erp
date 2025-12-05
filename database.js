
const path = require('path')
const fs = require('fs')
const Database = require('better-sqlite3')
const DB_PATH = path.join(__dirname, '..', 'data', 'erp.db')

function connect(){
  if (!fs.existsSync(path.dirname(DB_PATH))) fs.mkdirSync(path.dirname(DB_PATH), { recursive: true })
  const db = new Database(DB_PATH)
  return db
}

module.exports = { connect }
