"use client";

import { useCallback, useState } from "react";

import { useInterval } from "~/hooks/use-interval";

import { SnapSection } from "./snap-section";

export const SectionAvatarProfiles: React.FC<{ values: Array<string> }> = ({ values }) => {
	const [activeIdx, setActiveIdx] = useState(0);

	useInterval(
		useCallback(() => {
			setActiveIdx((activeIdx) => (activeIdx + 1) % values.length);
		}, [values.length]),
		5000
	);

	const activeValue = values[activeIdx];

	return (
		<SnapSection className="bg-brand-gradient px-8 py-16 md:px-16" id="avatar-profiles">
			<div className="mx-auto flex h-full w-full max-w-screen-2xl flex-col items-center justify-center gap-8">
				<div className="flex flex-col items-center justify-center gap-8 text-center">
					<h1 className="mt-8 font-montserrat text-5xl font-extrabold md:text-7xl">
						Avatar profiles
					</h1>
					<span className="h-[8ch] max-w-4xl font-nunito text-2xl font-normal leading-snug sm:text-3xl md:h-[5ch] md:text-5xl">
						{activeValue}
					</span>
				</div>
				<img className="lg:h-[60vh]" src="/images/profile-showcase.png" />
			</div>
		</SnapSection>
	);
};
