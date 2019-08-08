import React from 'react';

const Contents = props => {
    const {posts} = props;

    const styles = {
        flexWrapper:{
            width:1000,
            margin: '0 auto',// 마진으로 중앙정렬
            display: 'flex',
            flexFlow: 'row wrap',
            flexWrap: 'wrap',
            marginTop: 5
        },
        itemWrapper:{
            width:327,
            height:327,
            padding:3,
        },
        image: {
            width:'100%',
            height:'100%',
        }
    }
    return (  
        <div style={styles.flexWrapper}>
          {/* <h1 key={`post_id_${index}`}>{JSON.stringify(post)}</h1> */}
          {posts.map((post, index) => (
            <div style={styles.itemWrapper} key={`post_id_${index}`}>
              <img style={styles.image} src={post.url} alt=""/>
            </div>
          ))}
        </div>
      );
}

export default Contents;