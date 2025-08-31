import React from 'react'
export default function Button({ variant='solid', children, ...rest }){
  return <button className={['btn', variant==='solid'?'btn-solid':variant==='outline'?'btn-outline':'btn-ghost'].join(' ')} {...rest}>{children}</button>
}
