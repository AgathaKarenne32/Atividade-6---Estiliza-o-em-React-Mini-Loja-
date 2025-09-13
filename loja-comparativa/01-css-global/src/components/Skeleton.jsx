import React from 'react'
export default function Skeleton({ style={}, className='' }){
  return <div className={['skeleton', className].join(' ')} style={style} aria-hidden />
}