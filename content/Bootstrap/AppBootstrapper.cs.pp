using System;
using System.Collections.Generic;
using System.Linq;
using Caliburn.Micro;
using $rootnamespace$.ViewModels;
using Castle.MicroKernel.Registration;
using Castle.Windsor;

namespace $rootnamespace$.Bootstrap
{
    public class AppBootstrapper : Bootstrapper<IShellViewModel>
	{
		WindsorContainer _container;

		protected override void Configure()
		{
            _container = new WindsorContainer();

		    _container.AddFacility<EventRegistrationFacility>();

		    _container.Register(
		        Component.For<IWindowManager>().ImplementedBy<WindowManager>().LifestyleSingleton(),
		        Component.For<IEventAggregator>().ImplementedBy<EventAggregator>().LifestyleSingleton(),
                Classes.FromThisAssembly().InSameNamespaceAs<IShellViewModel>().WithServiceDefaultInterfaces().LifestyleTransient()
		        );
		}

		protected override object GetInstance(Type serviceType, string key)
		{
            if (string.IsNullOrEmpty(key))
            {
                return _container.Resolve(serviceType);
            }
		    return _container.Resolve(key, serviceType);
		}

		protected override IEnumerable<object> GetAllInstances(Type serviceType)
		{
			return _container.ResolveAll(serviceType).Cast<object>();
		}
	}
}