const LS_KEY = 'scorekeeper'

export const fetch = (key?: string) => {
  const data = JSON.parse(localStorage[LS_KEY] || '{}')

  return key ? data[key] : data
}

export const save = (key: string, value: any) => {
  const data = fetch()

  data[key] = value

  localStorage[LS_KEY] = JSON.stringify(data)
}
