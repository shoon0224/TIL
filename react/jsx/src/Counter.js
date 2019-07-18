import React, {Component} from 'react';


class Counter extends Component {

    state = {
        number: 0
    }
    handleIncrease = () => { // 왜 이함수들은 화살표 함수인가? this가 뭔지를 모른다.
        this.setState({
            number: this.state.number +1
        })
    }

    handleDecrease = () => {
        this.setState({
            number: this.state.number -1
        })
    }
    render () {
        return (
            <div>
                <h1>카운터</h1>
                <div>값: {this.state.number}</div>
                <button onClick={this.handleIncrease}>+</button>
                <button onClick={this.handleDecrease}>-</button>
            </div>
        );
    }
}

export default Counter;