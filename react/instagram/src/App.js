import React from 'react';
import { Navbar, Header, Contents } from './components'; //비구조화 할당(내가 원하는 것만 뽑아 쓰겠다.) //모듈화된 컴포넌트들을 임포트해준다.
import { PostApi } from './api';

class App extends React.Component {

  state = {
    posts: null
  }
  
  
  componentDidMount() {
    this._handleGetPosts();
  }



  render() {
    return (
      <div>
        <Navbar />
        <Header />
        {this.state.posts === null ? (
          <h3>Loadding...</h3>
        ) : (
            <Contents posts={this.state.posts} />
          )}
      </div>
    );
  }
  _handleGetPosts = async () => {
    const result = await PostApi.getPosts();
    setTimeout(() => {
      this.setState({
        posts: result.slice(0.10)
      })
    }, 1500)
  }
}
/**
 * 게시글 조회
 */



export default App;

//네브빠 헤더 컨텐츠 더 나아가 사이드바 이런걸로 나눌껀데 이게 한마디로 뭐냐
//그만큼의 컴포넌트를 만들어준다는 것이다.

