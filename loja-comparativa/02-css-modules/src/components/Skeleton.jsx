import React from 'react'
export default function Skeleton({style={},className=''}){ return <div className={className} style={{background:'linear-gradient(90deg, rgba(0,0,0,0.04) 25%, rgba(0,0,0,0.06) 50%, rgba(0,0,0,0.04) 75%)', ...style}} aria-hidden/> }
