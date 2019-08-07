const express = require('express'); //express를 불러온다.
const bodyParser = require('body-parser');//서버모듈을 위한기능까지 다선언할 수 있도록 만들어준다.
const app = express();//서버모듈을 위한기능까지 다선언할 수 있도록 만들어준다.
const port = process.env.PORT || 5000; //서버포트는 5000번 포트로 열어준다.

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));

app.get('/api/hello', (req,res) => {
    res.send({message: 'Hello Express!'});
});

app.listen(port, () => console.log(`Listening on port ${port}`));

