"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";

import { useToast } from "~/hooks/use-toast";
import { api } from "~/api";
import { User } from "~/api/user";

import { Button } from "../button";
import { ReportProfileModel } from "../modals/report-profile";
import { Tooltip, TooltipContent, TooltipTrigger } from "../tooltip";

export const BlockedActions: React.FC<{ user: User }> = ({ user }) => {
	const toasts = useToast();
	const router = useRouter();

	const [reportVisible, setReportVisible] = useState(false);

	return (
		<div className="flex gap-4">
			<Button
				className="w-fit"
				size="sm"
				onClick={async () => {
					await api.user
						.unblock(user.id)
						.then(() => {
							toasts.add("User blocked successfully");
							return router.refresh();
						})
						.catch(toasts.addError);
				}}
			>
				Unblock
			</Button>
			<ReportProfileModel
				user={user}
				visible={reportVisible}
				onVisibilityChange={setReportVisible}
			>
				<Tooltip>
					<TooltipTrigger asChild>
						<Button
							className="w-fit"
							size="sm"
							onClick={() => setReportVisible(true)}
						>
							Report
						</Button>
					</TooltipTrigger>
					<TooltipContent>Report profile</TooltipContent>
				</Tooltip>
			</ReportProfileModel>
		</div>
	);
};
