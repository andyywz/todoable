def stub_payload_api(action, url, payload, response)
  allow_any_instance_of(Todoable::Session).to receive(:invoke)
    .with(action, url, payload)
    .and_return(response)
end

def stub_api(action, url, response)
  allow_any_instance_of(Todoable::Session).to receive(:invoke)
    .with(action, url)
    .and_return(response)
end
