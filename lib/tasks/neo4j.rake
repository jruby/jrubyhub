task "db:test:prepare" do
  rm_rf FileList["tmp/neotest*"]
end
