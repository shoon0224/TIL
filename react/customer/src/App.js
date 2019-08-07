import React, { Component } from 'react';
import Customer from './components/Customer'
import './App.css';


const customers = [{//보내주고자 하는 데이터들 명시
  'id': 1,
  'image': 'https://placeimg.com/64/64/1', //보여주는이미지 크기가 64,64임
  'name': '이상훈',
  'birthday': '960224',
  'gender': '남자',
  'job': '대학생'
},
{
  'id': 2,
  'image': 'https://placeimg.com/64/64/2',
  'name': '홍길동',
  'birthday': '961111',
  'gender': '남자',
  'job': '프로그래머'
},
{
  'id': 3,
  'image': 'https://placeimg.com/64/64/3',
  'name': '최동길',
  'birthday': '962222',
  'gender': '여자',
  'job': '프로게이머'
},
]

class App extends Component {
  render() {
    return (
      <div>
        {customers.map(c => { return (<Customer key={c.id} id={c.id} image={c.image} name={c.name} birthday={c.birthday} gender={c.gender} job={c.job} />) })}
      </div>
    );
  }
}

export default App;