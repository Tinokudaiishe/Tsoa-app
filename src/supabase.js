import { createClient } from '@supabase/supabase-js'

const supabaseUrl  = import.meta.env.VITE_SUPABASE_URL
const supabaseKey  = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseKey) {
  console.warn('⚠️  Supabase env vars missing — running in offline/localStorage mode')
}

export const supabase = supabaseUrl && supabaseKey
  ? createClient(supabaseUrl, supabaseKey)
  : null

// ── Attendance ─────────────────────────────────────────────────
export async function fetchAttendance() {
  if (!supabase) return JSON.parse(localStorage.getItem('tsoa_signin') || '[]')
  const { data, error } = await supabase
    .from('attendance')
    .select('*')
    .order('created_at', { ascending: false })
  if (error) { console.error(error); return [] }
  return data
}

export async function insertAttendance(record) {
  if (!supabase) {
    const all = JSON.parse(localStorage.getItem('tsoa_signin') || '[]')
    const updated = [...all, record]
    localStorage.setItem('tsoa_signin', JSON.stringify(updated))
    return record
  }
  const { data, error } = await supabase.from('attendance').insert([record]).select().single()
  if (error) { console.error(error); return null }
  return data
}

// ── Documents ──────────────────────────────────────────────────
export async function fetchDocuments() {
  if (!supabase) return JSON.parse(localStorage.getItem('tsoa_docs') || '[]')
  const { data, error } = await supabase
    .from('documents')
    .select('*')
    .order('created_at', { ascending: false })
  if (error) { console.error(error); return [] }
  return data
}

export async function insertDocument(doc) {
  if (!supabase) {
    const all = JSON.parse(localStorage.getItem('tsoa_docs') || '[]')
    const updated = [...all, { ...doc, id: Date.now() }]
    localStorage.setItem('tsoa_docs', JSON.stringify(updated))
    return doc
  }
  const { data, error } = await supabase.from('documents').insert([doc]).select().single()
  if (error) { console.error(error); return null }
  return data
}

export async function deleteDocument(id) {
  if (!supabase) {
    const all = JSON.parse(localStorage.getItem('tsoa_docs') || '[]')
    localStorage.setItem('tsoa_docs', JSON.stringify(all.filter(d => d.id !== id)))
    return
  }
  const { error } = await supabase.from('documents').delete().eq('id', id)
  if (error) console.error(error)
}

// ── Problems ───────────────────────────────────────────────────
export async function fetchProblems() {
  if (!supabase) return []
  const { data, error } = await supabase
    .from('problems')
    .select('*')
    .order('created_at', { ascending: false })
  if (error) { console.error(error); return [] }
  return data
}

export async function insertProblem(problem) {
  if (!supabase) return problem
  const { data, error } = await supabase.from('problems').insert([problem]).select().single()
  if (error) { console.error(error); return null }
  return data
}

export async function updateProblem(id, updates) {
  if (!supabase) return
  const { error } = await supabase.from('problems').update(updates).eq('id', id)
  if (error) console.error(error)
}

export async function deleteProblem(id) {
  if (!supabase) return
  const { error } = await supabase.from('problems').delete().eq('id', id)
  if (error) console.error(error)
}
