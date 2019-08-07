import React, { Component } from 'react';
import PhoneInfo from './PhoneInfo';

class PhoneInfoList extends Component {
    static defaultProps = {
        data: []
    }
    render() {
        const { data, onRemove, onUpdate } = this.props;

        const list = data.map(
            info => (
                <PhoneInfo
                    onRemove={onRemove}
                    onUpdate={onUpdate}
                    info={info}
                    key={info.id}
                />
            ) // key값이 없다면 나중에 리스트중에서 중앙에 있는 값을 지워도 인덱스값이 정리 되지않고 그대로 남아있는다.
        );
        return (
            <div>
                {list}
            </div>
        );
    }
}

export default PhoneInfoList;