import React from 'react';
import axios from 'axios';
import Select from 'react-select';
import { render } from "preact";

const categoryOptions = [
  { value: 'transportation', label: 'Transportation' },
  { value: 'hotels', label: 'Hotels' },
  { value: 'restaurants', label: 'Restaurants' },
  { value: 'shops', label: 'Shops' },
  { value: 'sightseeing', label: 'Sightseeing' },
  { value: 'others', label: 'Activities/Others' },
]

export default class CategorySelect extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: 'Transportation'
    }
  }

  componentDidMount(val) {
    axios({
      method: 'get',
      url: '/traveling-safely-in-japan/category/' + val,
      data: {
        type: "hot",
        limit: 10
      }
    })
      .then(res => this.setState({ recipes: res.data }));

  }

  render() {
    return (
      <Select id="category_select"
        options={categoryOptions}
        // options=this.props.data
        // onChange={opt => console.log(opt.label, opt.value)}
        onChange={opt => this.componentDidMount(opt.value)}
      />
    );
  }
}
