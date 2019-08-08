export default {
    /**
     * 
     */
    getPosts: async () => { //동기식으로 바꿔준다.
        try {
            const url = 'https://jsonplaceholder.typicode.com/photos'
            const result = await fetch(url)
            const resultJson = result.json()
            return resultJson;
        } catch (e) {
            return [];
        }
    },


    setPost: () => { },

    removePost: () => { }

}