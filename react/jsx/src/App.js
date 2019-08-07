import React, { Component } from 'react';
import PhoneForm from './Component/PhoneForm';
import PhoneInfoList from './Component/PhoneInfoList';

class App extends Component {

  id = 3; //데이터를 추가할 때 마다 각 데이터의 고유한 id값이 들어가지게 한다. 
          //id값은 렌더링 되는 값이 아니기 때문에 굳이 state안에 안넣어줬다.

  state = { 
    information: [ //전화번호부 정보를 imformation에 들어간다.
      {
        id: 0,//이거 각각 아이디값 안주면 아래 디폴트 리스트들 한묶음으로 삭제 수정이 되버린다.
        name : '이상훈',
        phone: '010-0000-0000'
      },
      {
        id: 1,
        name : '박상훈',
        phone: '010-1234-0000'
      },
      {
        id: 2,
        name : '최상훈',
        phone: '010-4424-4444'
      },
    ],
    keyword:'',
  }
/**
 * 
 */
  handleChange = (e)  => { // 이름 검색할 때 쓸 함수
    this.setState({
      keyword: e.target.value,
    })
  }

/**
 * handleCreate함수는 data를 파라미터로 가져온다. (다른 컴포넌트로 부터 데이터르 가져온다.)
 */
  handleCreate = (data) => {//생성
    const { information } = this.state; //이건 비구조화 할당이다. --> this.state.informaiton.push(data); 이렇게 하면 절때 안된다.
    this.setState({ //언제나 setState를 사용해야 한다.
      information: information.concat(Object.assign({}, data, { //입력한 만큼 카운트가 된다.
        id: this.id++
        /**
         *  this.setState({
         *    information: this.state.information,
         * }) 이렇게 해도 안됨
         * 리액트에서는 꼭 불변성을 유지해줘야하 한다.
         * 어떠한 값을 수정하게 될 때 일단 언제나 setState를 사용해야하고
         * 내부에 있는 배열이나 객체를 바꾸게 될 때는 기존에 있는 배열이나 객체를 수정하지 않고
         * 그것을 기반으로 새로운 객체 혹은 배열을 만들어서 값을 주입해줘야 한다.
         * 그래서 push를 사용하는게 아니라 concat이라는 배열 내장 함수를 사용해야 한다.
         * concat을 사용하면 기존에 있던 배열은 수정하지 않고 새로운 배열을 만들어서 그 배열에다가 data를 넣어서 그 배열을 기존에 배열자리에 넣어준다.
         */
      }))
    });
  }

  /**
   * 
   */
  handleRemove = (id) => {//삭제
    const { information } = this.state;
    this.setState({
      information: information.filter(info => info.id !== id) //현재 information에다가 filter를 걸어서 information안에 들어있는 인포값이 인포.id가 파라미터로 받은 아이디가 아닌것들만 필터링 해달라
    });
  }

  /**
   * 
   */
  handleUpdate = (id, data) => { // 수정
    const { information } = this.state; //비구조 할당 문법
    this.setState({
      information: information.map(
        info => {
          if (info.id === id) {
            return {
              id,
              ...data,
            };
          }
          return info;
        }
      )
    });
  }

  /**
   * 
   */
  render() {//렌더링
    return (
      <div>
        <PhoneForm onCreate={this.handleCreate}/*onCreate라는 값에 위에서 만들어준 handleCreate를 전달*/ /> 
        <input
          value={this.state.keyword}
          onChange={this.handleChange} 
          placeholder="검색..."
        />
        <PhoneInfoList
          data={this.state.information.filter(
            info => info.name.indexOf(this.state.keyword) > -1
          )} 
          onRemove={this.handleRemove}
          onUpdate={this.handleUpdate}
        />
      </div>
    );
  }
}

export default App