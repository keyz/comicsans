import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: ":pink-slack-emoji:",
  description: "original taste",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="antialiased h-full">
      <body>{children}</body>
    </html>
  );
}
