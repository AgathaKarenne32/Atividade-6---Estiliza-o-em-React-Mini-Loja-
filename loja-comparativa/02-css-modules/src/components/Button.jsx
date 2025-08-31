import React from 'react'
import s from './Button.module.css'
export default function Button({variant='solid',children,...rest}){
  return <button className={variant==='solid'?s.solid:variant==='outline'?s.outline:s.ghost} {...rest}>{children}</button>
}
