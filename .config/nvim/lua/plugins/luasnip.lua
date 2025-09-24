return {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp",
	config = function()
		local ls = require("luasnip")
		local i = ls.insert_node
		local s = ls.snippet
		local t = ls.text_node
		local fmt = require("luasnip.extras.fmt").fmt
		local c = ls.choice_node
		local sn = ls.snippet_node
		ls.add_snippets("typescript", {
			s("header", {
				t({
					"/*",
					" * Project: uig-insured-client",
					string.format(" * File Created: %s", os.date("%A, %d %B %Y")),
					" * Author: Alex Heiner",
					" *",
					" * Copyright United Insurance Group. All rights reserved.",
					" */",
				}),
			}),
		})
		ls.add_snippets("cs", {
			s(
				"XML XML",
				fmt([[{}]], {
					c(1, {
						sn(
							nil,
							fmt(
								[[
                   <summary>{}</summary>
                   ]],
								{
									i(1, "Test test test"),
								}
							)
						),

						sn(
							nil,
							fmt(
								[[
                 <remarks>{}</remarks>
                 ]],
								{
									i(
										1,
										"Specifies that text contains supplementary information about the program element"
									),
								}
							)
						),

						sn(
							nil,
							fmt(
								[[
                <param name="{}">{}</param>
                ]],
								{
									i(1),
									i(2, "Specifies the name and description for a function or method parameter"),
								}
							)
						),

						sn(
							nil,
							fmt(
								[[
                <typeparam name="{}">{}</typeparam>
                ]],
								{
									i(1),
									i(2, "Specifies the name and description for a type parameter"),
								}
							)
						),

						sn(
							nil,
							fmt(
								[[
                <returns>{}</returns>
                ]],
								{
									i(1, "Describe the return value of a function or method"),
								}
							)
						),

						sn(
							nil,
							fmt(
								[[
                <exception cref="{}">{}</exception>
                ]],
								{
									i(1, "Exception type"),
									i(
										2,
										"Specifies the type of exception that can be generated and the circumstances under which it is thrown"
									),
								}
							)
						),

						sn(
							nil,
							fmt(
								[[
                <seealso cref="{}"/>
                ]],
								{
									i(
										1,
										"Specifies the type of exception that can be generated and the circumstances under which it is thrown"
									),
								}
							)
						),

						sn(
							nil,
							fmt(
								[[
                <para>{}</para>
                ]],
								{
									i(
										1,
										"Specifies a paragraph of text. This is used to separate text inside the remarks tag"
									),
								}
							)
						),

						sn(
							nil,
							fmt(
								[[
                <code>{}</code>
                ]],
								{
									i(
										1,
										"Specifies that text is multiple lines of code. This tag can be used by generators to display text in a font that is appropriate for code"
									),
								}
							)
						),

						sn(
							nil,
							fmt(
								[[
                <paramref name="{}"/>
                ]],
								{
									i(1, "Specifies a reference to a parameter in the same documentation comment"),
								}
							)
						),

						sn(
							nil,
							fmt(
								[[
                <typeparamref name="{}"/>
                ]],
								{
									i(1, "Specifies a reference to a type parameter in the same documentation comment"),
								}
							)
						),

						sn(
							nil,
							fmt(
								[[
                <c>{}</c>
                ]],
								{
									i(1, "Specifies a reference to a type parameter in the same documentation comment"),
								}
							)
						),

						sn(
							nil,
							fmt(
								[[
                <see cref="{}">{}</see>
                ]],
								{
									i(1, "reference"),
									i(2, "Specifies a reference to a type parameter in the same documentation comment"),
								}
							)
						),

						--
					}),
				})
			),
		})
	end,
}
