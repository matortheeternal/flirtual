import { Dispatch, FC, PropsWithChildren } from "react";
import { ShieldExclamationIcon } from "@heroicons/react/24/solid";
import { useRouter } from "next/navigation";

import { displayName, User } from "~/api/user";
import { api } from "~/api";
import { useAttributeList } from "~/hooks/use-attribute-list";
import { DrawerOrModal } from "~/components/drawer-or-modal";
import { Form, FormButton } from "~/components/forms";
import { InputSelect, InputLabel, InputTextArea } from "~/components/inputs";
import { useToast } from "~/hooks/use-toast";

interface ReportProfileModelFormProps {
	user: User;
	onVisibilityChange: Dispatch<boolean>;
}

const ReportProfileModelForm: FC<ReportProfileModelFormProps> = ({
	user,
	onVisibilityChange
}) => {
	const toasts = useToast();
	const router = useRouter();
	const reportReasons = useAttributeList("report-reason");

	return (
		<Form
			className="flex flex-col gap-8 rounded-3xl p-5 dark:text-white-20 sm:w-96"
			fields={{
				targetId: user.id,
				reasonId: reportReasons[0]?.id || null,
				message: ""
			}}
			onSubmit={async ({ reasonId, targetId, message }) => {
				if (!reasonId) return;
				await api.report.create({ body: { reasonId, targetId, message } });

				toasts.add("Thank you for your report");
				onVisibilityChange(false);

				return router.refresh();
			}}
		>
			{({ FormField }) => (
				<>
					<FormField
						className="flex flex-row items-center gap-4"
						name="targetId"
					>
						{() => (
							<>
								<ShieldExclamationIcon className="h-6 w-6" />
								<span className="text-xl">
									Report profile:{" "}
									<span data-sentry-mask>{displayName(user)}</span>
								</span>
							</>
						)}
					</FormField>
					<FormField name="reasonId">
						{(field) => (
							<>
								<InputSelect
									{...field.props}
									options={reportReasons.map((attribute) => ({
										key: attribute.id,
										label: attribute.name
									}))}
								/>
							</>
						)}
					</FormField>
					<FormField name="message">
						{(field) => (
							<>
								<InputLabel {...field.labelProps}>Message</InputLabel>
								<InputTextArea
									{...field.props}
									placeholder="Tell us a little more about this incident. If you'd like us to reach out for more details or further evidence, please include your contact info."
									rows={6}
								/>
							</>
						)}
					</FormField>
					<FormButton>Report</FormButton>
				</>
			)}
		</Form>
	);
};

type ReportProfileModelProps = PropsWithChildren<{
	user: User;
	visible: boolean;
	onVisibilityChange: Dispatch<boolean>;
}>;

export const ReportProfileModel: React.FC<ReportProfileModelProps> = ({
	user,
	children,
	visible,
	onVisibilityChange
}) => {
	return (
		<DrawerOrModal visible={visible} onVisibilityChange={onVisibilityChange}>
			<ReportProfileModelForm
				user={user}
				onVisibilityChange={onVisibilityChange}
			/>
			{children}
		</DrawerOrModal>
	);
};
