"use client";

import { QuestionMarkCircleIcon } from "@heroicons/react/24/outline";

import { api } from "~/api";
import { Form } from "~/components/forms";
import { FormButton } from "~/components/forms/button";
import { InlineLink } from "~/components/inline-link";
import { InputLabel, InputLabelHint, InputSwitch } from "~/components/inputs";
import { InputPrivacySelect } from "~/components/inputs/specialized";
import { useCurrentUser } from "~/hooks/use-current-user";

export const PrivacyForm: React.FC = () => {
	const { data: user } = useCurrentUser();
	if (!user || !user.preferences) return null;

	return (
		<Form
			className="flex flex-col gap-8"
			fields={{
				...user.preferences.privacy
			}}
			onSubmit={async (values, { reset }) => {
				const privacy = await api.user.preferences.updatePrivacy(user.id, values);
				reset(privacy);
			}}
		>
			{({ FormField }) => (
				<>
					<FormField name="personality">
						{(field) => (
							<>
								<InputLabel inline hint="Who can see your personality traits?">
									Personality privacy
								</InputLabel>
								<InputPrivacySelect {...field.props} />
							</>
						)}
					</FormField>
					<FormField name="sexuality">
						{(field) => (
							<>
								<InputLabel inline hint="Who can see your sexuality?">
									Sexuality privacy
								</InputLabel>
								<InputPrivacySelect {...field.props} />
							</>
						)}
					</FormField>
					<FormField name="country">
						{(field) => (
							<>
								<InputLabel inline hint="Who can see your country?">
									Country privacy
								</InputLabel>
								<InputPrivacySelect {...field.props} />
							</>
						)}
					</FormField>
					<FormField name="kinks">
						{(field) => (
							<>
								<InputLabel inline hint="Who can see your nsfw tags?">
									Kink privacy
								</InputLabel>
								<InputPrivacySelect {...field.props} />
							</>
						)}
					</FormField>
					<FormField name="analytics">
						{(field) => (
							<>
								<InputLabel
									inline
									hint={
										<InputLabelHint>
											<InlineLink className="flex w-fit items-center gap-2" href="/privacy-policy">
												<QuestionMarkCircleIcon className="w-4 shrink-0" />
												<span>Learn more</span>
											</InlineLink>
										</InputLabelHint>
									}
								>
									Opt-out of anonymous statistics?
								</InputLabel>
								<InputSwitch {...field.props} invert />
							</>
						)}
					</FormField>
					<FormButton>Update</FormButton>
				</>
			)}
		</Form>
	);
};
