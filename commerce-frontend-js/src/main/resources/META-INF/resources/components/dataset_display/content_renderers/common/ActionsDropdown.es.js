import ClayButton from '@clayui/button';
import ClayDropDown from '@clayui/drop-down';
import ClayIcon from '@clayui/icon';
import React, {useState} from 'react';

function ActionsDropdown(props) {
	const [active, setActive] = useState(false);

	return (
		<ClayDropDown
			active={active}
			onActiveChange={setActive}
			trigger={
				<ClayButton className="btn-sm px-1" displayType="unstyled">
					<ClayIcon symbol="ellipsis-v" />
				</ClayButton>
			}
		>
			<ClayDropDown.ItemList>
				<ClayDropDown.Group>
					{props.items.map((item, i) => (
						<ClayDropDown.Item href={item.href} key={i}>
							{item.icon && (
								<span className="pr-2">
									<ClayIcon symbol={item.icon} />
								</span>
							)}
							{item.label}
						</ClayDropDown.Item>
					))}
				</ClayDropDown.Group>
			</ClayDropDown.ItemList>
		</ClayDropDown>
	);
}

export default ActionsDropdown;
