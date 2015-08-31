class Cloudbrain < Formula
  desc "Platform for real-time sensor data analysis and visualization."
  homepage "http://demo.cloudbrain.rocks"
  url "https://pypi.python.org/packages/source/c/cloudbrain/cloudbrain-0.2.0.tar.gz"
  sha256 "0e7832bb161d2a4d694c2cc39c5c17e9ebb5d6e5da86d6eb1ab4acb9feff02aa"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "liblo"

  resource "pika" do
    url "https://pypi.python.org/packages/source/p/pika/pika-0.10.0b2.tar.gz"
    sha256 "f54e133dc0130420889e64cf0f2df8d6c7a67647c37a80b4f56350bd3a83d29a"
  end

  resource "pyliblo" do
    url "http://das.nasophon.de/download/pyliblo-0.9.2.tar.gz"
    sha256 "382ee7360aa00aeebf1b955eef65f8491366657a626254574c647521b36e0eb0"
  end

  def install
    # Dependencies
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[pika pyliblo].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # Cloudbrain
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "false"
  end
end
