import { Metadata } from "next";

import { ModelCard } from "~/components/model-card";
import { withAttributeList } from "~/api/attributes-server";

import { MatchmakingForm } from "./form";

export const metadata: Metadata = {
	title: "Matchmaking"
};

export default async function SettingsProfileMatchmakingPage() {
	const genders = (await withAttributeList("gender"))
		.filter((gender) => gender.metadata?.simple)
		.sort((a, b) => ((a.metadata?.order ?? 0) > (b.metadata?.order ?? 0) ? 1 : -1));

	return (
		<ModelCard className="sm:max-w-2xl" title="Matchmaking">
			<MatchmakingForm genders={genders} />
		</ModelCard>
	);
}
