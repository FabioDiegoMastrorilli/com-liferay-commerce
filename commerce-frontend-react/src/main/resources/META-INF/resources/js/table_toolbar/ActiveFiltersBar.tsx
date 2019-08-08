import React, { useState, useContext } from 'react';

import FilterResume from './Filter/Resume';

import FilterProps from './Filter/definitions';

import getAppContext from './Context';
import ClayIcon from '@clayui/icon';
import ClayButton from '@clayui/button';


const ActiveFiltersBar: React.FunctionComponent = (props) => {

    const {state, actions} = getAppContext();

    const filtersActive: FilterProps[] = state.filters.reduce(
        (acc: string[], filter: FilterProps) => !!filter.value ? acc.concat(filter.slug) : acc,
        []
    )

    console.log(filtersActive);

    return filtersActive.length ? (
        <nav className="tbar tbar-inline-md-down subnav-tbar subnav-tbar-primary subnav-tbar-light pt-3 pb-3 border-top">
            <div className="container-fluid container-fluid-max-xl">
                <ul className="tbar-nav tbar-nav-wrap">
                    <li className="tbar-item tbar-item-expand">
                        <div className="tbar-section">
                            {filtersActive.map((slug, i) => {
                                const filter: FilterProps = state.filters.reduce(
                                    (found, filter) => found || (filter.slug === slug ? filter : false),
                                    false
                                );
                                return (<FilterResume key={i} {...filter} />)
                            })}
                        </div>
                    </li>
                    <li className="tbar-item">
                        <div className="tbar-section">
                            <ClayButton
                                displayType="link"
                                className=" tbar-link btn-sm"
                                onClick={() => actions.resetFiltersValue()}
                            >
                                Reset filters
                            </ClayButton>
                        </div>
                    </li>
                </ul>
            </div>
        </nav>
    ) : null
}

export default ActiveFiltersBar