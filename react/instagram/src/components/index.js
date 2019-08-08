//하나의 컴포넌트를 모듈화시키기위해서 
//한마디로 하나의 객체로써 사용하려고 index.js를 선언한다.
//컴포넌트에 파일이 추가 될 때 그때 그때 입력해줄 것이다.
//그리고 뒤에 js가 생략가능하다.

export {default as Navbar} from './layout/Navbar'
export {default as Header} from './layout/Header'
export {default as Contents} from './layout/Contents'