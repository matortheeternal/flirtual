import { Metadata } from "next";
// eslint-disable-next-line import/named
import { cache } from "react";
import { redirect } from "next/navigation";

import { ConversationChatbox } from "~/hooks/use-talkjs";
import { displayName } from "~/api/user";
import { api } from "~/api";
import { urls } from "~/urls";
import { thruServerCookies } from "~/server-utilities";

import { getProfileUser } from "../../(sole-model)/[username]/profile-user";
import { ConversationAside } from "../aside";

export interface ConversationPageProps {
	params: {
		conversationId: string;
	};
}

const getConversation = cache(async (conversationId: string) => {
	return api.conversations
		.get(conversationId, thruServerCookies())
		.catch(() => redirect(urls.conversations.list()));
});

export async function generateMetadata({
	params
}: ConversationPageProps): Promise<Metadata> {
	const conversation = await getConversation(params.conversationId);
	const user = await getProfileUser(conversation.userId);

	return {
		title: displayName(user)
	};
}

export default async function ConversationPage({
	params
}: ConversationPageProps) {
	const conversation = await getConversation(params.conversationId);

	return (
		<>
			<ConversationAside activeConversationId={conversation.id} />
			<div className="flex h-full w-full flex-col items-center justify-center md:pl-8">
				<ConversationChatbox
					className="h-[calc(100vh-8rem)] w-full overflow-hidden shadow-brand-1 md:h-[32rem] md:rounded-xl"
					conversationId={conversation.id}
				/>
			</div>
		</>
	);
}
