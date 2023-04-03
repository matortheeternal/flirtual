"use client";
import { ArrowUturnLeftIcon, XMarkIcon } from "@heroicons/react/24/outline";
import { useRouter } from "next/navigation";
import { Dispatch, SetStateAction, useCallback, useEffect, useState } from "react";
import { twMerge } from "tailwind-merge";

import { api } from "~/api";
import { ProspectRespondType, ProspectKind, RespondProspectBody } from "~/api/matchmaking";
import { User } from "~/api/user";
import { HeartIcon } from "~/components/icons/heart";
import { PeaceIcon } from "~/components/icons/peace";
import { Profile } from "~/components/profile/profile";
import { Tooltip } from "~/components/tooltip";
import { useSession } from "~/hooks/use-session";
import { useToast } from "~/hooks/use-toast";

import { OutOfProspects } from "./out-of-prospects";

export interface ProspectListProps {
	prospects: Array<User>;
	kind: ProspectKind;
}

const ProspectActionBar: React.FC<{
	userId: string;
	mode: ProspectKind;
	setProspectIdx: Dispatch<SetStateAction<number>>;
}> = ({ userId, mode, setProspectIdx }) => {
	const [respondHistory, setRespondHistory] = useState<Array<RespondProspectBody>>([]);
	const toasts = useToast();

	const respond = useCallback(
		async (type: ProspectRespondType, kind: ProspectKind) => {
			const body = {
				type,
				kind,
				mode: mode !== kind ? mode : undefined,
				userId
			};

			await api.matchmaking
				.respondProspect({ body })
				.then(() => {
					setRespondHistory((respondHistory) => [...respondHistory, body]);
					return setProspectIdx((prospectIdx) => prospectIdx + 1);
				})
				.catch(toasts.addError);
		},
		[userId, mode, setProspectIdx, toasts.addError]
	);

	const respondReverse = useCallback(async () => {
		setRespondHistory((respondHistory) => {
			const lastRespond = respondHistory.pop();
			if (!lastRespond) return [];

			void api.matchmaking.reverseRespondProspect({
				body: lastRespond
			});

			setProspectIdx((prospectIdx) => prospectIdx - 1);
			return respondHistory;
		});
	}, [setProspectIdx]);

	return (
		<div className="h-32 w-full dark:bg-black-70 sm:h-0">
			<div className="pointer-events-none fixed bottom-0 left-0  flex  w-full items-center justify-center bg-gradient-to-b from-transparent to-black-90/50 p-8">
				<div className="pointer-events-auto flex h-32 items-center gap-3 overflow-hidden rounded-xl pb-16 text-white-10">
					<Tooltip value="Undo previous">
						<button
							className="flex h-fit items-center gap-3 rounded-xl bg-black-60 p-4 shadow-brand-1 disabled:cursor-not-allowed disabled:brightness-50"
							disabled={respondHistory.length === 0}
							type="button"
							onClick={respondReverse}
						>
							<ArrowUturnLeftIcon className="w-5" strokeWidth={3} />
						</button>
					</Tooltip>
					{mode === "love" && (
						<Tooltip value="Like profile">
							<button
								className="flex items-center justify-center gap-3 rounded-xl bg-brand-gradient px-6 py-4 shadow-brand-1 sm:w-40"
								type="button"
								onClick={() => respond("like", mode)}
							>
								<HeartIcon className="w-8 shrink-0" gradient={false} />
								<span className="hidden font-montserrat text-lg font-extrabold md:inline">
									Like
								</span>
							</button>
						</Tooltip>
					)}
					<Tooltip value="Friend profile">
						<button
							type="button"
							className={twMerge(
								"flex items-center justify-center gap-3 rounded-xl px-6 py-4 shadow-brand-1",
								mode === "friend" ? "w-40 bg-brand-gradient" : "bg-black-50"
							)}
							onClick={() => respond("like", "friend")}
						>
							<PeaceIcon className="w-8 shrink-0" gradient={false} />
							<span className="hidden font-montserrat text-lg font-extrabold md:inline">Homie</span>
						</button>
					</Tooltip>
					<Tooltip value="Pass profile">
						<button
							className="flex h-fit items-center gap-3 rounded-xl bg-black-60 p-4 shadow-brand-1"
							type="button"
							onClick={() => respond("pass", mode)}
						>
							<XMarkIcon className="w-5" strokeWidth={3} />
						</button>
					</Tooltip>
				</div>
			</div>
		</div>
	);
};

export const ProspectList: React.FC<ProspectListProps> = ({ kind, prospects }) => {
	const router = useRouter();
	const [session] = useSession();

	const [prospectIdx, setProspectIdx] = useState(0);
	const prospect = prospects[prospectIdx];

	useEffect(() => {
		if (kind === "friend") document.documentElement.classList.add("friend-mode");
		return () => document.documentElement.classList.remove("friend-mode");
	}, [kind]);

	return (
		<>
			{prospect ? (
				<>
					<Profile key={prospect.id} user={prospect} />
					<ProspectActionBar mode={kind} setProspectIdx={setProspectIdx} userId={prospect.id} />
				</>
			) : (
				<OutOfProspects />
			)}
			{session?.user.tags?.includes("debugger") && (
				<div className="py-8">
					<button
						type="button"
						onClick={async () => {
							await api.matchmaking.resetProspect();
							router.refresh();
						}}
					>
						Reset queue
					</button>
				</div>
			)}
		</>
	);
};
