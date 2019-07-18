import React from 'react';

const MyName = ({ name }) => { //이 문법은 비구조화 할당이라고 한다.
    return <div>안녕하세요! 제 이름은 {name}입니다.</div>
};

MyName.defaultProps = {
    name: '이상훈'
}


export default MyName; 