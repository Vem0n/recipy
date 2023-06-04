const express = require('express');

const favController = require('../controller/api');
const isAuth = require('../middleware/isAuth');

const router = express.Router();
const auth = isAuth;

router.get('/favourites', auth, favController.getItems);
router.post('/favourite', auth, favController.createItem)

router.get('/favourite/:itemId',auth ,favController.getItem)

module.exports = router;