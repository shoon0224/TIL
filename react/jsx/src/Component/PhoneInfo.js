import React, { Component, Fragment } from 'react';

class PhoneInfo extends Component {

    state = {
        editing: false,
        name: '',
        phone: ''
    }
/**
 * 원래 이벤트 한번실행할 때 마다 전체렌더링이 되어 문제가 되었는데 이 API를 통해서 바뀌지 않을 경우 렌더링을 시켜주지 않는다.
 * 
 * 
 */
    shouldComponentUpdate(nextProps, nextState) { 
        //원래 이벤트 한번실행할 때 마다 전체렌더링이 되어 문제가 되었는데 이 API를 통해서 바뀌지 않을 경우 렌더링을 시켜주지 않는다.
        if (this.state !== nextState){
            return true;
        }
        return this.props.info !== nextProps.info; //프롭스로 받아온 인포값이 달라질 경우
    }
    

    handleRemove = () => {
        const { info, onRemove } = this.props;
        onRemove(info.id);
    }


    handleToggleEdit = () => { //editing 값을 반전시켜준다.
        //true -> false
        //onUpdate
        //false -> true
        //state에 info 값들 넣어주기
        const {info, onUpdate} = this.props;
        if(this.state.editing){
            onUpdate(info.id, {
                name: this.state.name,
                phone: this.state.phone
            });
        }else {
            this.setState({
                name: info.name,
                phone: info.phone
            });
        }
        this.setState({
            editing: !this.state.editing
        })
    }

    handleChange = (e) => {
        this.setState({
            [e.target.name]: e.target.value
        });
    }

    render() {
        const { name, phone } = this.props.info; //비구조 할당 방식으로 받아온다.
        const { editing } = this.state;
        const style = {
            border: '1px solid black',
            padding: '8px',
            margin: '8px',
        };

        console.log(name);
        return (

            <div style={style}>
                {
                    editing ? (
                        <Fragment>
                            <div>
                                <input
                                    name="name"
                                    onChange={this.handleChange}
                                    value={this.state.name}
                                />
                            </div>
                            <div>
                                <input
                                    name="phone"
                                    onChange={this.handleChange}
                                    value={this.state.phone}
                                />
                            </div>
                        </Fragment>
                    ) : (
                            <Fragment>
                                <div><b>{name}</b></div>
                                <div>{phone}</div>
                            </Fragment>
                        )
                }

                <button onClick={this.handleRemove}>삭제</button>
                <button onClick={this.handleToggleEdit}>{editing ? '적용' : '수정'}</button>
            </div >

        );
    }
}

export default PhoneInfo;