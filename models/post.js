const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const itemSchema = new Schema({
    title: {
        type: String,
        required: true
    },
    receivedId: {
        type: String,
        required: true
    },
    imageurl: {
        type: String,
        required: true
    },
    owner: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true
    }
})

module.exports = mongoose.model('Item', itemSchema)