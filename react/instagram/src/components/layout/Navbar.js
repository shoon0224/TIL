import React from 'react';

const styles = {
    container:{
        width: '100%', //브라우저 마다 다르기 때문에 100%를 주자
        borderBottom: '1px solid #3f3f3f', // 아래에 선을 주겠다.
        padding:0, //왼쪽으로 부터 15정도 떨어지겠다.
        display:'flex',// 네브바 옆에 검색착을 넣고싶으면 flex를 주면 된다.
        alignItems:'center', //검색창을 센터로 가져온다.
        justifyContent: 'flex-start'//끝으로 보내겠다.
    },
    searchBar:{
        width: 300,
        height: 30,
        padding:10,
        margin: 10, //search바가 너무 네브에 붙어있기 때문에
        backgroundColor: '#f3f3f3',
        borderRadius: 25,
        border:'1px solid #dbdbdb',
    }
}

const Navbar = () => {
    return (
        <div style={styles.container}>
            <h1>Navber</h1>
            <div>
                <input type="text" style={styles.searchBar}/>
            </div>
        </div>
    );
}

export default Navbar;