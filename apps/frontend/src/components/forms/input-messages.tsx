import {
	CheckIcon,
	ExclamationCircleIcon,
	ExclamationTriangleIcon,
	InformationCircleIcon
} from "@heroicons/react/24/outline";
import { FC, PropsWithChildren } from "react";
import { twMerge } from "tailwind-merge";

import { capitalize } from "~/utilities";

import { IconComponent } from "../icons";

export type FormMessageType = "error" | "warning" | "success" | "informative";
export type FormMessageSize = "sm" | "md";

export interface FormMessage {
	type: FormMessageType;
	size?: FormMessageSize;
	value: string;
}

const formMessageStyle: Record<FormMessageType, string> = {
	error: "text-red-600 dark:text-red-400",
	warning: "text-yellow-600 dark:text-yellow-400",
	success: "text-green-600 dark:text-green-400",
	informative: "text-black-60 dark:text-white-50"
};

const formMessageIcon: Record<FormMessageType, IconComponent> = {
	error: ExclamationCircleIcon,
	warning: ExclamationTriangleIcon,
	success: CheckIcon,
	informative: InformationCircleIcon
};

const formMessageSize: Record<FormMessageSize, string> = {
	sm: "text-md",
	md: "text-lg"
};

export type FormMessageProps = PropsWithChildren<Omit<FormMessage, "value">>;

export const FormMessage: FC<FormMessageProps> = (props) => {
	const { type, size = "md", children } = props;
	const Icon = formMessageIcon[type];

	return (
		<div
			className={twMerge(
				"flex gap-2 font-nunito",
				formMessageStyle[type],
				formMessageSize[size]
			)}
		>
			<Icon className="mt-1 h-6 w-6 shrink-0" />
			<span>{children}</span>
		</div>
	);
};

export interface FormInputMessagesProps {
	messages?: Array<FormMessage>;
}

export const FormInputMessages: React.FC<FormInputMessagesProps> = ({
	messages
}) => {
	if (!messages || messages.length === 0) return null;

	return (
		<div className="flex flex-col gap-2">
			{messages.map(({ value, ...message }, messageIndex) => (
				<FormMessage key={messageIndex} {...message}>
					{capitalize(value)}
				</FormMessage>
			))}
		</div>
	);
};
