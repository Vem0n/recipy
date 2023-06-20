const { default: mongoose } = require('mongoose');
const Item = require('../models/post')
const User = require('../models/user')

exports.getItems = async (req, res, next) => {
  try {
    const results = await Item.find();

    if (!results) {
      const error = new Error('404 No items found');
      res.status(404);
      throw error;
    }

    res.status(200).json({ message: 'Success', results: results });
  } catch (e) {
    if (!e.statusCode) {
      e.statusCode = 500;
    }
    next(e);
  }
};


exports.createItem = async (req, res, next) => {
  try {
    const title = req.body.title;
    const imageurl = req.body.imageurl;
    const receivedId = req.body.receivedId;

    const item = new Item({
      title: title,
      receivedId: receivedId,
      imageurl: imageurl,
      owner: req.userId
    });

    const result = await item.save();
    const user = await User.findById(req.userId);
    const owner = user;

    if (user) {
      // @ts-ignore
      user.favourites.push(item);
      await user.save();
    }

    res.status(201).json({
      message: '✌️😎',
      item: item,
      owner: { _id: owner?._id, name: owner?.name }
    });

    console.log(result);
  } catch (e) {
    console.log(e);
  }
};


exports.deletePost = async (req, res, next) => {
  try {
    const itemId = req.params._id;

    const item = await Item.findById(itemId);
    if (!item) {
      console.log('Could not find item.');
    }

    if (item?.owner.toString() !== req.userId) {
      console.log('Not authorized!');
    }

    await Item.findByIdAndRemove(itemId);
    const user = await User.findById(req.userId);

    if (user) {
      // @ts-ignore
      user.favourites.pull(itemId);
      await user.save();
    }

    res.status(200).json({ message: 'Deleted post.' });
  } catch (err) {
    if (!err.statusCode) {
      err.statusCode = 500;
    }
    next(err);
  }
};

exports.deletePosts = async (req, res, next) => {
  try {
    const userId = req.userId;

    const posts = await Item.find({ owner: userId });

    if (posts.length > 0) {
      await Item.deleteMany({ owner: userId });

      const user = await User.findById(userId);

      if (user) {
        user.favourites = [];
        await user.save();
      }
    }

    res.status(200).json({ message: 'Deleted all posts.' });
  } catch (err) {
    if (!err.statusCode) {
      err.statusCode = 500;
    }
    next(err);
  }
};


exports.getItem = async (req, res, next) => {
  try {
    const itemId = req.params.itemId;

    const result = await Item.findById(itemId);
    if (!result) {
      const error = new Error('404 No item found');
      res.status(404);
      throw error;
    }

    res.status(200).json({ message: 'Success', result: result });
  } catch (e) {
    if (!e.statusCode) {
      e.statusCode = 500;
    }
    next(e);
  }
};
