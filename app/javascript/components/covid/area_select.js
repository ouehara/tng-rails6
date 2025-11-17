import React from 'react';

import Select from 'react-select';
import makeAnimated from 'react-select/animated';
// import { colourOptions } from '../data';

const areaOptions = [
    { value: 'chocolate', label: 'Hokkaido' },
    { value: 'strawberry', label: 'Akita' },
    { value: 'vanilla', label: 'Nagano' },
    { value: 'vanilla', label: 'Tokyo' },
    { value: 'orange', label: 'Kyushu' },
    { value: 'yellow', label: 'Okinawa' },
]

const animatedComponents = makeAnimated();

export default function AreaMulti() {
  return (
    <Select
      closeMenuOnSelect={false}
      components={animatedComponents}
      isMulti
      options={areaOptions}
    />
  );
}