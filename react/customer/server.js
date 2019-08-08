const express = require('express'); //express를 불러온다.
const bodyParser = require('body-parser');//서버모듈을 위한기능까지 다선언할 수 있도록 만들어준다.
const app = express();//서버모듈을 위한기능까지 다선언할 수 있도록 만들어준다.
const port = process.env.PORT || 5000; //서버포트는 5000번 포트로 열어준다.

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get('/api/customers', (req, res) => {
    res.send([
        {
            'id': 1,
            'image': 'https://placeimg.com/64/64/1',
            'name': '이상훈',
            'birthday': '960224',
            'gender': '남자',
            'job': '대학생'
        },
        {
            'id': 2,
            'image': 'https://placeimg.com/64/64/2',
            'name': '홍길동',
            'birthday': '961111',
            'gender': '남자',
            'job': '프로그래머'
        },
        {
            'id': 3,
            'image': 'https://placeimg.com/64/64/3',
            'name': '최동길',
            'birthday': '962222',
            'gender': '여자',
            'job': '프로게이머'
        }
    ]);
});

app.listen(port, () => console.log(`Listening on port ${port}`));

