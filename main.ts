
import { app, BrowserWindow, ipcMain } from 'electron'
import path from 'path'
import fs from 'fs'
const Database = require('better-sqlite3')

const DB_PATH = path.join(__dirname, '..', 'data', 'erp.db')
let db

function initDatabase(){
  const dir = path.dirname(DB_PATH)
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true })
  const needInit = !fs.existsSync(DB_PATH)
  db = new Database(DB_PATH)
  if (needInit){
    const initSql = fs.readFileSync(path.join(__dirname, '..', 'sql', 'init.sql'), 'utf8')
    db.exec(initSql)
    const bcrypt = require('bcryptjs')
    const hash = bcrypt.hashSync('admin123', 10)
    db.prepare('INSERT INTO users (nome, email, senha_hash, role) VALUES (?, ?, ?, ?)').run('Administrador', 'admin@solutions.local', hash, 'admin')
  }
}

export { db as database }

function createWindow(){
  const mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      nodeIntegration: false,
      contextIsolation: true
    }
  })

  if (process.env.NODE_ENV === 'development'){
    mainWindow.loadURL('http://localhost:5173')
  } else {
    mainWindow.loadFile(path.join(__dirname, '..', 'dist', 'index.html'))
  }
}

app.whenReady().then(()=>{
  initDatabase()
  createWindow()
  app.on('activate', ()=>{ if (BrowserWindow.getAllWindows().length===0) createWindow() })
})

app.on('window-all-closed', ()=>{ if (process.platform !== 'darwin') app.quit() })

// Basic IPC: examples for modules (clients, products); more can be added similarly.
ipcMain.handle('clients:list', () => db.prepare('SELECT * FROM clients ORDER BY nome').all())
ipcMain.handle('products:list', () => db.prepare('SELECT * FROM products ORDER BY descricao').all())
ipcMain.handle('os:list', () => db.prepare('SELECT * FROM os ORDER BY data_abertura DESC').all())
ipcMain.handle('dashboard:data', () => {
  // minimal sample data
  return { os:{ totalOS: db.prepare("SELECT COUNT(*) AS total FROM os").get().total || 0, osAbertas:0, osConcluidas:0 }, orcamentos:{ totalOrcamentos:0, orcamentosAprovados:0 }, financeiro:{ financeiroReceber:0, financeiroPagar:0 }, estoque:{ produtosCriticos:0 } }
})
