import React, { Component } from 'react';

class PhoneForm extends Component {

    input = React.createRef(); // 커서위치를 이름에 놓기위함 , DOM에 직접접근하는 것이다.


    state = { // 현재 컴포넌트의 상태
        name: '',
        phone: '',

    }
    /**
     * input에서 변경이벤트가 발생할 때 처리 할 함수, (e)라는 객체를 파리미터로 받아온다.
     * e는 이벤트 객체이고 앞으로 어떻게 수정할 것인지 알 수 있다.
     * 앞으로 값이 어떻게 바뀔껀지 e.target.value 안에 들어있다.
     * render함수 안에있는 input == e.target이 되고 그 input(e.target)의 값이 vuale이다.
     * 인풋값이 바뀔 때 마다 vlaue값이 바뀐다.
     * [e.target.name] 에서 e.target은 input이고 그위에 name은 state의 name이 아니라 input에 있는 name값이 들어가게 되는것이다.
     */
    handleChange = (e) => {
        this.setState({
            [e.target.name]: e.target.value
        });
    }

    /**
     * HTML에서 form속성이 submit버튼을 누르면 한번 페이지가 새로고침되게 되어있다. 이걸방지해야한다 우리는 새로고침 할 필요가 없기 때문이다.
     * 페이지가 리로딩되는걸 방지하기 위해서 e.preventDefault를해준다. --> 원래 해야하하는 작업인데 안한다.
     */
    handleSubmit = (e) => {
        e.preventDefault();//페이지가 리로딩하는걸 방지하기 위해서
        this.props.onCreate(this.state); //App.js에 있던 onCreate함수를 호출한다.
        this.setState({// 입력하고 등록하면 칸이 초기화 된다.
            name: '',
            phone: ''
        })
        this.input.current.focus(); // 이 input의 포커스를 이름에 맞춰준다.

    }
/**
 * <input
                name="phone" 여기에 있는 name값이 [e.target.name]에 들어가면서 state에 있는 값이 바뀌게 되는 것이다.
                placeholder="전화번호"
                onChange={this.handleChange}//두번째 input도 똑같이 해준다.
                value={this.state.phone}
            />
 */
    render() {
        return (
            <form onSubmit={this.handleSubmit}//onSubmit이라는 props로 전달해준다.
            >
                <input // 이 input에서 처리할 함수가 위 handleChange의 e 객체이다.
                    name="name"//여러가지 input을 만드려면 name값을 설정해주어야 한다.
                    placeholder="이름"//플레이스홀더는 아무것도 입력되지 않았을 때 기본적으로 보여주는 값
                    onChange={this.handleChange} //onChange 값이 바뀔 때 씀 그안에 this.handleChange를 해주면서 handleChange 함수를 불러온다.
                    value={this.state.name}// value안에 state에 있는 name을 대입한다.
                    ref={this.input}// 이름과 전화번호를 입력한 후 커서의 위치를 전화번호가 아닌 이름으로 옮기고 싶을 때 사용한다. Ref는 DOM에 직접 접근한다.
                />

                <input //두번째 input
                    name="phone"
                    placeholder="전화번호"
                    onChange={this.handleChange}//두번째 input도 똑같이 해준다.
                    value={this.state.phone} 
                />
                <button type="submit">등록</button>
            </form>
        );
    }
}

export default PhoneForm;