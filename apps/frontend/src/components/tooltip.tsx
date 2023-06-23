"use client";

import * as React from "react";
import * as TooltipPrimitive from "@radix-ui/react-tooltip";
import { twMerge } from "tailwind-merge";

const TooltipProvider = TooltipPrimitive.Provider;

const Tooltip = TooltipPrimitive.Root;

const TooltipTrigger = TooltipPrimitive.Trigger;

const TooltipContent = React.forwardRef<
	React.ElementRef<typeof TooltipPrimitive.Content>,
	React.ComponentPropsWithoutRef<typeof TooltipPrimitive.Content>
>(({ className, sideOffset = 4, ...props }, reference) => (
	<TooltipPrimitive.Content
		ref={reference}
		sideOffset={sideOffset}
		className={twMerge(
			"z-50 max-w-[95vw] overflow-hidden rounded-lg bg-black-80 px-3 py-1 font-nunito text-base text-white-20 shadow-brand-1 animate-in fade-in-50 data-[side=bottom]:slide-in-from-top-1 data-[side=left]:slide-in-from-right-1 data-[side=right]:slide-in-from-left-1 data-[side=top]:slide-in-from-bottom-1 dark:bg-white-20 dark:text-black-80",
			className
		)}
		{...props}
	/>
));

TooltipContent.displayName = TooltipPrimitive.Content.displayName;

export { Tooltip, TooltipTrigger, TooltipContent, TooltipProvider };
