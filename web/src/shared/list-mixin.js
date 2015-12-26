import _ from 'lodash';

export default {
  indexOf (item) {
    return _.findIndex(this.props[this.listName], (thisItem) => (
      item.id === thisItem.id
    ));
  },

  newId () {
    const ids = _.pluck(this.props[this.listName], 'id');
    if (!ids.length) { return 0; }
    return Math.max(...ids) + 1;
  },

  update (item) {
    this.replace(item, item);
  },

  remove (item) {
    this.replace(item);
  },

  replace (item, replacement) {
    const index = this.indexOf(item);
    if (index > -1) {
      const args = [index, 1];
      if (replacement) { args.push(replacement); }
      this.props[this.listName].splice(...args);
      this.save();
    }
  },

  save () {
    this.props.onUpdate(this.props[this.listName]);
  },
};
