def _impl(ctx):
  # ctx.new_file is used for temporary files.
  # If it should be visible for user, declare it in rule.outputs instead.
  f = ctx.new_file(ctx.configuration.bin_dir, "hello")
  # As with outputs, each time you declare a file,
  # you need an action to generate it.
  ctx.file_action(output=f, content=ctx.attr.input_content)

  ctx.action(
      inputs=[f],
      outputs=[ctx.outputs.out],
      executable=ctx.executable.binary,
      progress_message="Executing %s" % ctx.executable.binary.short_path,
      arguments=[
          f.path,
          ctx.outputs.out.path,  # Access the output file using
                                 # ctx.outputs.<attribute name>
      ]
  )

execute = rule(
  implementation=_impl,
  attrs={
      "binary": attr.label(cfg=HOST_CFG, mandatory=True, allow_files=True,
                           executable=True),
      "input_content": attr.string(),
      "out": attr.output(mandatory=True),
      },
)
